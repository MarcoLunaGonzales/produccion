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
        function validarIngresoFormulaMaestraDetalleFPActividad(){
            if(document.getElementById("form2:codMaquina").value==0){
                    alert('seleccione un Material');
                    return false;
                }
            return true;
        }
        function validarEdicionFormulaMaestraDetalleFPActividad(){
            if(document.getElementById("form3:codMaquina").value==0){
                    alert('seleccione un Material');
                    return false;
                }
            return true;
        }
       </script>
        </head>
        <body >
            <a4j:form id="form1">
                <div align="center">
                    <h:outputText value="#{ManagedFormulaMaestraDetalleFPActividadMaquinaria.cargarContenidoFormulaMaestraDetalleFPActividadMaquinaria}"/>
                    <h:outputText styleClass="outputTextTitulo"  value="Listado de Maquinarias de Actividad" />
                    <br><br>

                    <rich:dataTable value="#{ManagedFormulaMaestraDetalleFPActividadMaquinaria.formulaMaestraDetalleFPActividadMaquinariaList}" var="data"
                                    id="dataFormulaMaestraFPActividadMaquinaria"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                                    onRowMouseOver="this.style.backgroundColor='#DDE3E4';" 
                                    headerClass="headerClassACliente" >


                        <h:column>
                            <f:facet name="header">
                                <h:outputText value=""  />                                
                            </f:facet>
                            <h:selectBooleanCheckbox value="#{data.checked}"  />
                        </h:column>
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Maquinaria"  />
                            </f:facet>
                            <h:outputText value="#{data.maquinaria.nombreMaquina}" />
                        </h:column>                        
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Caudal"  />
                            </f:facet>
                            <h:outputText value="#{data.caudalMaquinaria}" />
                        </h:column>
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Unidades Caudal"  />
                            </f:facet>
                            <h:outputText value="#{data.unidadesCaudalMaquinaria.nombreUnidadVelocidad}" />
                        </h:column>
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Velocidad"  />
                            </f:facet>
                            <h:outputText value="#{data.velocidadMaquinaria}" />
                        </h:column>
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Unidades Velocidad"  />
                            </f:facet>
                            <h:outputText value="#{data.unidadesVelocidadMaquinaria.nombreUnidadVelocidad}" />
                        </h:column>
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Tiempo"  />
                            </f:facet>
                            <h:outputText value="#{data.tiempoMaquinaria}" />
                        </h:column>
                        
                    </rich:dataTable>
                    <%-- <ws:datascroller fordatatable="dataAreasEmpresa"  />--%>
                    <br>                    
                    <a4j:commandButton value="Agregar" styleClass="btn" onclick="javascript:Richfaces.showModalPanel('panelAgregarFormulaMaestraDetalleFPActividadMaquinaria')"
                    action="#{ManagedFormulaMaestraDetalleFPActividadMaquinaria.agregarFormulaMaestraDetalleFPActividadMaquinaria_action}"
                    reRender="contenidoAgregarFormulaMaestraDetalleFPActividadMaquinaria" />
                    <a4j:commandButton value="Editar"  styleClass="btn" onclick="javascript:if(validarSeleccion('form1:dataFormulaMaestraFPActividadMaquinaria')==false){return false;}else{Richfaces.showModalPanel('panelEditarFormulaMaestraDetalleFPActividadMaquinaria')}"
                    action="#{ManagedFormulaMaestraDetalleFPActividadMaquinaria.editarFormulaMaestraDetalleFPActividadMaquinaria_action}"
                    reRender="contenidoEditarFormulaMaestraDetalleFPActividadMaquinaria" />
                    <a4j:commandButton value="Eliminar"  styleClass="btn" onclick="javascript:if(confirm('Esta Seguro de Eliminar??')==false || validarSeleccion('form1:dataFormulaMaestraFPActividadMaquinaria')==false){return false;}"
                    action="#{ManagedFormulaMaestraDetalleFPActividadMaquinaria.eliminarFormulaMaestraDetalleFPActividadMaquinaria_action}"
                    reRender="dataFormulaMaestraFPActividadMaquinaria"/>

                    <a4j:commandButton styleClass="btn" value="Cancelar" onclick="location='../formulaMaestraDetalleFPActividad/navegadorFormulaMaestraDetalleFPActividad.jsf'" />
                    

                </div>
                <!--cerrando la conexion-->
                <h:outputText value="#{ManagedFrecuenciaMantenimientoMaquinaria.closeConnection}"  />
                
            </a4j:form>



             <rich:modalPanel id="panelAgregarFormulaMaestraDetalleFPActividadMaquinaria" minHeight="150"  minWidth="400"
                                     height="250" width="310"
                                     zindex="200"
                                     headerClass="headerClassACliente"
                                     resizeable="false" style="overflow :auto" >
                        <f:facet name="header">
                            <h:outputText value="Maquinaria Actividad Fase"/>
                        </f:facet>
                        <a4j:form id="form2">
                        <h:panelGroup id="contenidoAgregarFormulaMaestraDetalleFPActividadMaquinaria">
                            <h:panelGrid columns="3">
                                <h:outputText value="Maquinaria" styleClass="outputText1" />
                                <h:outputText value="::" styleClass="outputText1" />
                                <h:selectOneMenu styleClass="inputText" value="#{ManagedFormulaMaestraDetalleFPActividadMaquinaria.formulaMaestraDetalleFPActividadMaquinaria.maquinaria.codMaquina}" id="codMaquina">
                                    <f:selectItems value="#{ManagedFormulaMaestraDetalleFPActividadMaquinaria.maquinariasList}" />                                    
                                </h:selectOneMenu>
                                
                                <h:outputText value="Caudal" styleClass="outputText1" />
                                <h:outputText value="::" styleClass="outputText1" />
                                <h:inputText value="#{ManagedFormulaMaestraDetalleFPActividadMaquinaria.formulaMaestraDetalleFPActividadMaquinaria.caudalMaquinaria}" styleClass="inputText"/>

                                <h:outputText value="Unidades Caudal" styleClass="outputText1" />
                                <h:outputText value="::" styleClass="outputText1" />
                                <h:selectOneMenu styleClass="inputText" value="#{ManagedFormulaMaestraDetalleFPActividadMaquinaria.formulaMaestraDetalleFPActividadMaquinaria.unidadesCaudalMaquinaria.codUnidadVelocidad}" >
                                    <f:selectItems value="#{ManagedFormulaMaestraDetalleFPActividadMaquinaria.unidadesCaudalList}" />
                                </h:selectOneMenu>

                                <h:outputText value="Velocidad" styleClass="outputText1" />
                                <h:outputText value="::" styleClass="outputText1" />
                                <h:inputText value="#{ManagedFormulaMaestraDetalleFPActividadMaquinaria.formulaMaestraDetalleFPActividadMaquinaria.velocidadMaquinaria}" styleClass="inputText"/>

                              <h:outputText value="Unidades Velocidad" styleClass="outputText1" />
                                <h:outputText value="::" styleClass="outputText1" />
                                <h:selectOneMenu styleClass="inputText" value="#{ManagedFormulaMaestraDetalleFPActividadMaquinaria.formulaMaestraDetalleFPActividadMaquinaria.unidadesVelocidadMaquinaria.codUnidadVelocidad}" >
                                    <f:selectItems value="#{ManagedFormulaMaestraDetalleFPActividadMaquinaria.unidadesVelocidadList}" />
                                </h:selectOneMenu>
                                

                                <h:outputText value="Tiempo" styleClass="outputText1" />
                                <h:outputText value="::" styleClass="outputText1" />
                                <h:inputText   value="#{ManagedFormulaMaestraDetalleFPActividadMaquinaria.formulaMaestraDetalleFPActividadMaquinaria.tiempoMaquinaria}" styleClass="outputText1"/>

                            </h:panelGrid>
                                <div align="center">
                                <a4j:commandButton styleClass="btn" value="Registrar" 
                                onclick="if(validarIngresoFormulaMaestraDetalleFPActividad()==false){return false;}else{javascript:Richfaces.hideModalPanel('panelAgregarFormulaMaestraDetalleFPActividadMaquinaria');}"
                                action="#{ManagedFormulaMaestraDetalleFPActividadMaquinaria.registrarFormulaMaestraDetalleFPActividadMaquinaria_action}" reRender="dataFormulaMaestraFPActividadMaquinaria"
                                                    />                                
                                <input type="button" value="Cancelar" onclick="javascript:Richfaces.hideModalPanel('panelAgregarFormulaMaestraDetalleFPActividadMaquinaria')" class="btn" />
                                </div>
                        </h:panelGroup>
                        </a4j:form>
            </rich:modalPanel>

            <rich:modalPanel id="panelEditarFormulaMaestraDetalleFPActividadMaquinaria" minHeight="150"  minWidth="400"
                                     height="250" width="310"
                                     zindex="200"
                                     headerClass="headerClassACliente"
                                     resizeable="false" style="overflow :auto" >
                        <f:facet name="header">
                            <h:outputText value="Editar Fase Formula Maestra"/>
                        </f:facet>
                        <a4j:form id="form3">
                        <h:panelGroup id="contenidoEditarFormulaMaestraDetalleFPActividadMaquinaria">
                           <h:panelGrid columns="3">
                                <h:outputText value="Maquinaria" styleClass="outputText1" />
                                <h:outputText value="::" styleClass="outputText1" />
                                <h:selectOneMenu styleClass="inputText" value="#{ManagedFormulaMaestraDetalleFPActividadMaquinaria.formulaMaestraDetalleFPActividadMaquinaria.maquinaria.codMaquina}" id="codMaquina">
                                    <f:selectItems value="#{ManagedFormulaMaestraDetalleFPActividadMaquinaria.maquinariasList}" />
                                </h:selectOneMenu>

                                <h:outputText value="Caudal" styleClass="outputText1" />
                                <h:outputText value="::" styleClass="outputText1" />
                                <h:inputText value="#{ManagedFormulaMaestraDetalleFPActividadMaquinaria.formulaMaestraDetalleFPActividadMaquinaria.caudalMaquinaria}" styleClass="inputText"/>

                                <h:outputText value="Unidades Caudal" styleClass="outputText1" />
                                <h:outputText value="::" styleClass="outputText1" />
                                <h:selectOneMenu styleClass="inputText" value="#{ManagedFormulaMaestraDetalleFPActividadMaquinaria.formulaMaestraDetalleFPActividadMaquinaria.unidadesCaudalMaquinaria.codUnidadVelocidad}" >
                                    <f:selectItems value="#{ManagedFormulaMaestraDetalleFPActividadMaquinaria.unidadesCaudalList}" />
                                </h:selectOneMenu>

                                <h:outputText value="Velocidad" styleClass="outputText1" />
                                <h:outputText value="::" styleClass="outputText1" />
                                <h:inputText value="#{ManagedFormulaMaestraDetalleFPActividadMaquinaria.formulaMaestraDetalleFPActividadMaquinaria.velocidadMaquinaria}" styleClass="inputText"/>

                              <h:outputText value="Unidades Velocidad" styleClass="outputText1" />
                                <h:outputText value="::" styleClass="outputText1" />
                                <h:selectOneMenu styleClass="inputText" value="#{ManagedFormulaMaestraDetalleFPActividadMaquinaria.formulaMaestraDetalleFPActividadMaquinaria.unidadesVelocidadMaquinaria.codUnidadVelocidad}" >
                                    <f:selectItems value="#{ManagedFormulaMaestraDetalleFPActividadMaquinaria.unidadesVelocidadList}" />
                                </h:selectOneMenu>


                                <h:outputText value="Tiempo" styleClass="outputText1" />
                                <h:outputText value="::" styleClass="outputText1" />
                                <h:inputText   value="#{ManagedFormulaMaestraDetalleFPActividadMaquinaria.formulaMaestraDetalleFPActividadMaquinaria.tiempoMaquinaria}" styleClass="outputText1"/>

                            </h:panelGrid>
                                <div align="center">
                                <a4j:commandButton styleClass="btn" value="Guardar" 
                                onclick="if(validarEdicionFormulaMaestraDetalleFPActividad()==false){return false;}else{javascript:Richfaces.hideModalPanel('panelEditarFormulaMaestraDetalleFPActividadMaquinaria');}"
                                
                                action="#{ManagedFormulaMaestraDetalleFPActividadMaquinaria.guardarEdicionFormulaMaestraFPActividadMaquinaria_action}" reRender="dataFormulaMaestraFPActividadMaquinaria"
                                                    />
                                <input type="button" value="Cancelar" onclick="javascript:Richfaces.hideModalPanel('panelEditarFormulaMaestraDetalleFPActividadMaquinaria')" class="btn" />
                                </div>
                        </h:panelGroup>
                        </a4j:form>
            </rich:modalPanel>

        </body>
    </html>
    
</f:view>

